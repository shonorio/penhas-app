import 'persistent_storage.dart';

abstract class ICollectionStore<T> {
  String get name;

  Future<Iterable<T>> all();

  Stream<Iterable<T>> watchAll();

  Future<void> put(String key, T value);

  Future<void> removeAll(Iterable<String> keys);
}

mixin CollectionStore<T> on ICollectionStore<T> {
  IPersistentStorageFactory get storageFactory;

  late final IPersistentStorage storage = storageFactory.create(name);

  @override
  Future<Iterable<T>> all() => storage.all();

  @override
  Stream<Iterable<T>> watchAll() => storage.watchAll();

  @override
  Future<void> put(String key, T value) => storage.put(key, value);

  @override
  Future<void> removeAll(Iterable<String> keys) => storage.removeAll(keys);
}

mixin SerializableCollectionStore<T> on ICollectionStore<T>
    implements CollectionStore<T> {
  T deserialize(String source);

  String serialize(T object);

  @override
  Future<Iterable<T>> all() =>
      storage.all<String>().then((value) => value.map(deserialize));

  @override
  Stream<Iterable<T>> watchAll() =>
      storage.watchAll<String>().map((value) => value.map(deserialize));

  @override
  Future<void> put(String key, T value) => storage.put(key, serialize(value));
}
