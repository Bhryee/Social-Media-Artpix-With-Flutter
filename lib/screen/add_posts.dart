import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sketch_app/screen/add_text_posts.dart';
import 'package:easy_localization/easy_localization.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _mediaList = [];
  AssetPathEntity? _selectedAlbum;
  File? _selectedFile;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  _fetchAlbums() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      _albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      if (_albums.isNotEmpty) {
        setState(() {
          _selectedAlbum = _albums[0];
        });
        _fetchMediaForAlbum(_selectedAlbum!);
      }
    }
  }

  _fetchMediaForAlbum(AssetPathEntity album) async {
    final List<AssetEntity> media = await album.getAssetListPaged(page: 0, size: 60);
    setState(() {
      _mediaList = media;
      if (_mediaList.isNotEmpty) {
        _selectFile(_mediaList[0]);
      }
    });
  }

  _selectFile(AssetEntity asset) async {
    final file = await asset.file;
    setState(() {
      _selectedFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text('Yeni Gönderi'.tr(), style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _selectedFile != null
                ? () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPostTextScreen(_selectedFile!),
            ))
                : null,
            child: Text('İleri'.tr(), style: TextStyle(color: Color(0xFF1C869E))),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 350,
              height: 350,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: 375,
                  height: 375,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _selectedFile != null
                        ? Image.file(_selectedFile!, fit: BoxFit.cover)
                        : Container(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButton<AssetPathEntity>(
                      value: _selectedAlbum,
                      isExpanded: false,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      underline: Container(),
                      items: _albums.map((album) {
                        String dropdownItemText = album.name == "Recent" ? "Yakın Zamandakiler" : album.name;
                        return DropdownMenuItem<AssetPathEntity>(
                          value: album,
                          child: Text(dropdownItemText),
                        );
                      }).toList(),
                      onChanged: (album) {
                        if (album != null) {
                          setState(() {
                            _selectedAlbum = album;
                          });
                          _fetchMediaForAlbum(album);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: _mediaList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectFile(_mediaList[index]),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), //BURAYA TEKRAR BAK
                      child: FutureBuilder<Uint8List?>(
                        future: _mediaList[index].thumbnailData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}