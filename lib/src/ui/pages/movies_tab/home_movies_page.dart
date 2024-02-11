import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:movie_app/src/data/api/bloc/api_bloc.dart';
import 'package:movie_app/src/data/api/enum/api_movie_type.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
import 'package:movie_app/src/data/models/genre/genre_entity.dart';
import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_entity.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/storage/data_storage.dart';
import 'package:movie_app/src/utils/utils.dart';
import 'package:sizer/sizer.dart';

class HomeVideoAppPage extends StatefulWidget {
  static const String route = "/movies";

  const HomeVideoAppPage({super.key});

  @override
  State<HomeVideoAppPage> createState() => _HomeVideoAppPageState();
}

class _HomeVideoAppPageState extends State<HomeVideoAppPage> {
  bool enableAllFunctions = true;
  int page = 1;
  int typeSelected = 1;
  int currentIndex = 0;
  PageController controller = PageController(viewportFraction: 0.85);
  List<int> genresSelected = <int>[];
  List<MovieModel> movies = <MovieModel>[];
  List<MovieModel> upcoming = <MovieModel>[];
  List<MovieModel> topRated = <MovieModel>[];
  List<MovieModel> popular = <MovieModel>[];
  List<MovieModel> nowPlaying = <MovieModel>[];
  MovieDetailsModel? details;
  AccountModel? account;
  Debouncer debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    context.read<ApiBloc>().add(GetMoviesEvent(1, null, MovieCatType.upcoming));
    context.read<ApiBloc>().add(GetMoviesEvent(1, null, MovieCatType.topRated));
    context.read<ApiBloc>().add(GetMoviesEvent(1, null, MovieCatType.popular));
    context
        .read<ApiBloc>()
        .add(GetMoviesEvent(1, null, MovieCatType.nowPlaying));
    context.read<ApiBloc>().add(GetMoviesEvent(1, null, MovieCatType.general));
    loadAccount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadAccount() {
    final Storage storage = Storage();

    account = storage.getAccount();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiBloc, ApiState>(
      listener: (BuildContext context, ApiState state) {
        if (state is SuccessInfoState) {
          switch (state.type) {
            case MovieCatType.upcoming:
              state.films?.forEach((element) {
                upcoming.add(element);
              });

            case MovieCatType.topRated:
              state.films?.forEach((element) {
                topRated.add(element);
              });
            case MovieCatType.popular:
              state.films?.forEach((element) {
                popular.add(element);
              });
            case MovieCatType.nowPlaying:
              state.films?.forEach((element) {
                nowPlaying.add(element);
              });
            case MovieCatType.general:
              state.films?.forEach((element) {
                movies.add(element);
              });

            default:
              details = state.dettails;
          }
        }

        if (state is ErrorAppState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.message)));

          if (typeSelected == 5) {
            page--;
          }

          if (state.closeModal ?? false) {
            context.pop();
          }
        }
      },
      builder: (BuildContext context, ApiState state) {
        return Container(
          color: const Color(0xFF060c2b),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFF060c2b),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "¿Qué ver hoy?",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                        ClipOval(
                          child: Container(
                            height: 6.h,
                            width: 6.h,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.w),
                                borderRadius: BorderRadius.circular(50)),
                            child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl:
                                    "${environment.baseUrlImages}${account?.avatar_path}",
                                placeholder: (_, __) =>
                                    const SpinKitRipple(color: Colors.white),
                                errorListener: (e) {},
                                imageBuilder: (BuildContext context,
                                    ImageProvider image) {
                                  return Image(
                                    image: image,
                                    fit: BoxFit.fitWidth,
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    _buildOptionsHeader(),
                    Expanded(
                        child: state is MovieLoaderState
                            ? const SpinKitPulse(
                                color: Colors.white,
                              )
                            : _buildPageBuild(state))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageBuild(ApiState state) {
    return SizedBox.expand(
      child: Column(
        children: [
          if (typeSelected == 5)
            SizedBox(
              height: 2.h,
            ),
          if (typeSelected == 5)
            BlocBuilder<ApiBloc, ApiState>(builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 5.h,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 3.w,
                    );
                  },
                  itemCount: (state.catMovies ?? <GenreModel>[]).length,
                  itemBuilder: (context, index) {
                    return _optionBuild(state.catMovies?[index].name ?? '',
                        state.catMovies?[index].id ?? 0, onTap: () {
                      if (genresSelected.contains(state.catMovies?[index].id)) {
                        genresSelected.removeWhere(
                            (element) => element == state.catMovies?[index].id);
                      } else {
                        genresSelected.add(state.catMovies?[index].id ?? 0);
                      }

                      debouncer.run(() {
                        page = 1;

                        movies.clear();

                        context.read<ApiBloc>().add(GetMoviesEvent(
                            page, genresSelected, MovieCatType.general));
                      });

                      setState(() {});
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              );
            }),
          if (typeSelected == 5)
            SizedBox(
              height: 2.h,
            ),
          Expanded(
            child: PageView.builder(
              pageSnapping: true,
              allowImplicitScrolling: true,
              padEnds: true,
              itemCount: (typeSelected == 1
                      ? upcoming.length
                      : typeSelected == 2
                          ? topRated.length
                          : typeSelected == 3
                              ? nowPlaying.length
                              : typeSelected == 4
                                  ? popular.length
                                  : movies.length) +
                  (state is MovieLoaderPaginationState ? 1 : 0),
              controller: controller,
              onPageChanged: (indexPage) {
                currentIndex = indexPage;
                if (typeSelected == 5) {
                  if (indexPage > movies.length - 3) {
                    page++;
                    context.read<ApiBloc>().add(GetMoviesEvent(
                        page, genresSelected, MovieCatType.general));
                  }
                }
              },
              itemBuilder: (BuildContext context, int index) {
                if (typeSelected == 5) {
                  if (index > (movies.length - 1)) {
                    return const Center(
                      child: SpinKitSpinningLines(
                        color: Colors.white,
                      ),
                    );
                  }
                }

                return InkWell(
                  onTap: () {
                    context
                        .read<ApiBloc>()
                        .add(GetDetailsMovieEvent((typeSelected == 1
                                    ? upcoming
                                    : typeSelected == 2
                                        ? topRated
                                        : typeSelected == 3
                                            ? nowPlaying
                                            : typeSelected == 4
                                                ? popular
                                                : movies)[index]
                                .id ??
                            1));

                    showDetails();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl:
                                  "${environment.baseUrlImages}${(typeSelected == 1 ? upcoming : typeSelected == 2 ? topRated : typeSelected == 3 ? nowPlaying : typeSelected == 4 ? popular : movies)[index].poster_path}",
                              placeholder: (_, __) =>
                                  const SpinKitRipple(color: Colors.white),
                              errorListener: (e) {},
                              errorWidget: (context, url, error) {
                                return Image.asset('assets/images/image.png',
                                    fit: BoxFit.fitWidth);
                              },
                              imageBuilder:
                                  (BuildContext context, ImageProvider image) {
                                return Image(
                                  image: image,
                                  fit: BoxFit.fitWidth,
                                );
                              }),
                        ),
                        _buildTitle((typeSelected == 1
                                    ? upcoming
                                    : typeSelected == 2
                                        ? topRated
                                        : typeSelected == 3
                                            ? nowPlaying
                                            : typeSelected == 4
                                                ? popular
                                                : movies)[index]
                                .title ??
                            ''),
                        _buildDateAndRate(
                            (typeSelected == 1
                                        ? upcoming
                                        : typeSelected == 2
                                            ? topRated
                                            : typeSelected == 3
                                                ? nowPlaying
                                                : typeSelected == 4
                                                    ? popular
                                                    : movies)[index]
                                    .release_date ??
                                '',
                            (typeSelected == 1
                                        ? upcoming
                                        : typeSelected == 2
                                            ? topRated
                                            : typeSelected == 3
                                                ? nowPlaying
                                                : typeSelected == 4
                                                    ? popular
                                                    : movies)[index]
                                    .vote_average ??
                                0)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateStars(double rate) {
    return AnimatedRatingStars(
      initialRating: rate * 5 / 10,
      minRating: 0.0,
      maxRating: 5.0,
      filledColor: Colors.amber,
      emptyColor: Colors.white.withOpacity(0.3),
      filledIcon: Icons.star,
      halfFilledIcon: Icons.star_half,
      emptyIcon: Icons.star_border,
      onChanged: (double val) {},
      displayRatingValue: true,
      interactiveTooltips: true,
      customFilledIcon: Icons.star,
      customHalfFilledIcon: Icons.star_half,
      customEmptyIcon: Icons.star_border,
      starSize: 15.0,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      readOnly: true,
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25),
      ),
    );
  }

  Widget _buildDateAndRate(String date, double rate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          date.split('-')[0],
          style: const TextStyle(color: Colors.white),
        ),
        _rateStars(rate)
      ],
    );
  }

  Widget _buildOptionsHeader() {
    return SizedBox(
      height: 5.h,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _optionBuild("Próximamente", 1),
          SizedBox(
            width: 2.w,
          ),
          _optionBuild("Mejores valoradas", 2),
          SizedBox(
            width: 2.w,
          ),
          _optionBuild("Del momento", 3),
          SizedBox(
            width: 2.w,
          ),
          _optionBuild("Populares", 4),
          SizedBox(
            width: 2.w,
          ),
          _optionBuild("Categorias", 5),
        ],
      ),
    );
  }

  Widget _optionBuild(String text, int optionValue, {Function()? onTap}) {
    return InkWell(
      onTap: onTap ??
          () {
            typeSelected = optionValue;

            setState(() {});
          },
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: (genresSelected.contains(optionValue) ||
                            optionValue == typeSelected)
                        ? 4
                        : 2,
                    color: (genresSelected.contains(optionValue) ||
                            optionValue == typeSelected)
                        ? const Color(0xFF546ee6)
                        : const Color(0xFF35385c)))),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> showDetails() async {
    await showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Builder(builder: (context) {
            return AlertDialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.black.withOpacity(0.96),
                content:
                    BlocBuilder<ApiBloc, ApiState>(builder: (context, state) {
                  if (state is MovieLoaderDetailsState) {
                    return SizedBox(
                      width: 90.w,
                      height: 90.h,
                      child: const SpinKitFadingCircle(
                        color: Colors.white,
                      ),
                    );
                  }

                  return Container(
                      color: Colors.transparent,
                      width: 90.w,
                      height: 90.h,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: _buildTitle(details?.title ?? '')),
                              IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  (details?.genres ?? <GenreEntity>[])
                                      .map((GenreEntity e) => e.name ?? '')
                                      .toList()
                                      .join(' / '),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Bootstrap.stopwatch,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "${details?.runtime ?? 0} MINS",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              Expanded(child: Container()),
                              _rateStars(details?.vote_average ?? 0)
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              details?.overview ?? '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          const Text(
                            "REPARTO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Wrap(
                            spacing: 3.w,
                            children: (details?.cast ?? <CastEntity>[])
                                .map((CastEntity e) => _buildActorImage(
                                    e.name ?? '', e.profile_path ?? ''))
                                .toList(),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          const Text(
                            "PRODUCCIÓN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Wrap(
                            spacing: 3.w,
                            children: (details?.production_companies ??
                                    <ProductionCompaniesEntity>[])
                                .map((ProductionCompaniesEntity e) =>
                                    _buildActorImage(
                                        e.name ?? '', e.logo_path ?? '',
                                        imageColor: Colors.white))
                                .toList(),
                          ),
                        ],
                      ));
                }));
          }),
        );
      },
    );
  }

  Widget _buildActorImage(String name, String imageUrl, {Color? imageColor}) {
    return SizedBox(
      width: 70.w / 3,
      height: 25.h,
      child: Column(
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: "${environment.baseUrlImages}$imageUrl",
                placeholder: (_, __) =>
                    const SpinKitRipple(color: Colors.white),
                errorListener: (e) {},
                errorWidget: (BuildContext context, String url, Object error) {
                  return Image.asset("assets/images/image.png",
                      fit: BoxFit.fitWidth);
                },
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Image(
                    image: image,
                    color: imageColor,
                    fit: BoxFit.fitWidth,
                  );
                }),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
