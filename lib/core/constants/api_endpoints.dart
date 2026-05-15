class ApiEndpoints {
  // We use a private constructor to prevent this class from being instantiated.
  // We only use it to hold static constant strings to keep our code clean.
  ApiEndpoints._();

  // ----------------------------------------------------
  // MangaFire
  // ----------------------------------------------------
  static const String mangaFireBaseUrl = 'https://mangafire.to';

  // Endpoint to filter/search for manga. Usually takes query parameters like ?keyword=naruto
  static const String mangaFireSearch = '$mangaFireBaseUrl/filter';

  // Optional endpoints if you plan to scrape home page sections
  static const String mangaFireHome = '$mangaFireBaseUrl/home';

  // ----------------------------------------------------
  // AnimePahe (If you are also including the Anime source)
  // ----------------------------------------------------
  static const String animePaheBaseUrl = 'https://animepahe.ru';
  static const String animePaheSearch = '$animePaheBaseUrl/api?m=search&q=';

  // ----------------------------------------------------
  // AniList APIs (Highly recommended for high-quality metadata)
  // ----------------------------------------------------
  // Sometimes scraped sources have bad cover images. You can hit AniList's
  // GraphQL API with the title of the manga to get a pristine cover image.
  static const String anilistGraphql = 'https://graphql.anilist.co';

  // ----------------------------------------------------
  // Proxy (if you run into CORS/Cloudflare limits in the future and set up a proxy backend)
  // ----------------------------------------------------
  // static const String proxyEndpoint = 'https://your-custom-proxy.com/api/proxy';
}