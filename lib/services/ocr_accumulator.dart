class OCRAccumulator {

  String merge(
    List<String> texts,
  ) {

    final words =
        <String>{};

    for (final text
        in texts) {

      final split =
          text.split(' ');

      words.addAll(split);
    }

    return words.join(' ');
  }
}