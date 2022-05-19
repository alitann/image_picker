import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_collage/bloc/bloc/bottom_navigation_bloc.dart';

class MockBottomNavigationBloc extends MockBloc<BottomNavigationEvent, int> implements BottomNavigationBloc {}

void main() {
  group('BottomNavigationBloc Listen', () {
    test("Mock the BottomNavigationBloc's stream!", () {
      final bloc = MockBottomNavigationBloc();
      whenListen(bloc, Stream.fromIterable([0, 1, 2, 3]));
      expectLater(bloc.stream, emitsInOrder(<int>[0, 1, 2, 3]));
    });
  });

  group('BottomNavigationBloc', () {
    blocTest<BottomNavigationBloc, int>(
      'emits [1] when TabBarChangeEvent is added with 1',
      build: () => BottomNavigationBloc(),
      act: (bloc) => bloc.add(TabBarChangeEvent(1)),
      expect: () => const <int>[1],
    );

    blocTest<BottomNavigationBloc, int>(
      'emits [0] when TabBarChangeEvent is added with 0',
      build: () => BottomNavigationBloc(),
      act: (bloc) => bloc.add(TabBarChangeEvent(0)),
      expect: () => const <int>[0],
    );
  });
}
