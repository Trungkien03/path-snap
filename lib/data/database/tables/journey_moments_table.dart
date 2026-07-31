import 'package:drift/drift.dart';
import 'journeys_table.dart';

class JourneyMoments extends Table {
  TextColumn get id => text()();
  TextColumn get journeyId =>
      text().references(Journeys, #id, onDelete: KeyAction.cascade)();
  TextColumn get imagePath => text()();
  TextColumn get note => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
