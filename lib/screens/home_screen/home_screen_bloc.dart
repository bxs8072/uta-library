import 'dart:async';

class HomeScreenBloc {
  final StreamController<int> _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream;

  get dispose => _controller.close();

  update(int index) {
    _controller.sink.add(index);
  }
}
