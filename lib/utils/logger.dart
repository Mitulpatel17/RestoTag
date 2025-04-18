class Console {
  static bool debug = true;

  static void log(Object msg) {
    if (debug) {
      print(msg);
    }
  }
}
