
import './firebase.dart';
import '../actions/actions.dart';
import '../store.dart';
import './firebase-redux.dart';

void loadInitialData({ retry = 0 }) {
  AppStore.dispatch(FetchingData.Fetching);
  database
    .getIntialData()
    .then((snapshot) {
      addSnapshotToRedux(snapshot);
      AppStore.dispatch(FetchingData.Completed);
    })
    .catchError((_) {
      if (retry > 4) {
        AppStore.dispatch(FetchingData.Error);
      } else {
        loadInitialData(retry: retry + 1);
      }
    });
}
