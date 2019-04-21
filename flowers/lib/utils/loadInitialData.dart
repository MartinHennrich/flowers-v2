
import './firebase.dart';
import '../actions/actions.dart';
import '../store.dart';
import './firebase-redux.dart';

void loadInitialData() {
  AppStore.dispatch(FetchingData.Fetching);
  database
    .getIntialData()
    .then((snapshot) {
      addSnapshotToRedux(snapshot);
      AppStore.dispatch(FetchingData.Completed);
    })
    .catchError((_) {
      AppStore.dispatch(FetchingData.Error);
    });
}
