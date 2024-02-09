enum Environment {
  env(
      appName: 'Movies App',
      baseURL: 'https://api.themoviedb.org/3',
      debugPrint: true,
      baseUrlImages: "https://image.tmdb.org/t/p/original",
      apiToken:
          "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YmVmZWVmZmNmMmZkZGFjODMzYzIzNDU2OTc3YjAxYyIsInN1YiI6IjY1YzUxODBhMmQ1MzFhMDE4NGM1MTZhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nLPFr2RnT3xcQ28LiEwTfy_87C_GqS3QQKFaQTS7o9c");

  const Environment(
      {required this.appName,
      required this.baseURL,
      required this.apiToken,
      required this.debugPrint,
      required this.baseUrlImages});

  final String appName;
  final String baseURL;
  final String apiToken;
  final bool debugPrint;
  final String baseUrlImages;
}
