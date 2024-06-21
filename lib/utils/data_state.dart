abstract class DataState<T, E>{
  final T? data;
  final E? exception;
  final int? code;

  const DataState({this.data, this.exception, this.code});
}

class Success<T> extends DataState<T, dynamic>{
  const Success({super.data, super.code});
}

class Failure<E> extends DataState<dynamic, E>{
  const Failure({super.exception, super.code});
}