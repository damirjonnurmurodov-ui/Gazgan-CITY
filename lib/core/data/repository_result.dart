class RepositoryResult<T> {
  const RepositoryResult.live(this.data) : message = null;

  const RepositoryResult.fallback(this.data, {required this.message});

  final T data;
  final String? message;

  bool get isFallback => message != null;
}
