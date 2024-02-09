enum Environment {
  env(
      appName: 'Movies App',
      baseURL: '',
      debugPrint: true,
      apiToken: "",
      googleApiKey: "AIzaSyDKNTHLH7ap44KaPaGHldFandyahe7yTS4");

  const Environment(
      {required this.appName,
      required this.baseURL,
      required this.apiToken,
      required this.debugPrint,
      required this.googleApiKey});

  final String appName;
  final String baseURL;
  final String googleApiKey;
  final String apiToken;
  final bool debugPrint;
}
