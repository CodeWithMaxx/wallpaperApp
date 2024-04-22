import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wally/model/wallyModel.dart';

class WallyHomePage extends StatefulWidget {
  const WallyHomePage({super.key});

  @override
  State<WallyHomePage> createState() => _WallyHomePageState();
}

class _WallyHomePageState extends State<WallyHomePage> {
  late Future<wallyModel> WallpapersList;
  Future<wallyModel> FetchWallpaper(String searchWallpaper) async {
    final String ApiEndpoint =
        "https://api.pexels.com/v1/search?query=$searchWallpaper&per_page=300";
    final String ApiKey =
        "hHt0yZ145mhGUdZPHOXB3wB0yT9SkVN5y9zO0namAeZa4zjNJnbUkhdL";
    var responce = await http.get(
      Uri.parse(ApiEndpoint),
      headers: {"Authorization": ApiKey},
    );
    if (responce.statusCode == 200) {
      final result = await jsonDecode(responce.body);
      return wallyModel.fromJson(result);
    } else {
      return wallyModel();
    }
  }

  final searchController = TextEditingController();

  @override
  void initState() {
    WallpapersList = FetchWallpaper("space");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: WallpapersList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(top: 15),
                    sliver: SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 10,
                      title: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(.8)),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "search wallpapers.....",
                              suffixIcon: IconButton(
                                  onPressed: () => setState(() {
                                        WallpapersList = FetchWallpaper(
                                            searchController.text.toString());
                                      }),
                                  icon: const Icon(Icons.search))),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    sliver: SliverToBoxAdapter(
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 380),
                          itemCount: snapshot.data!.photos!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.network(
                                snapshot.data!.photos![index].src!.portrait
                                    .toString(),
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              Get.snackbar("Server Error", "Data not found");
            }
            return const SizedBox();
          }),
    );
  }
}
