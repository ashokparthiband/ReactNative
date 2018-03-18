import {combineReducers,createStore} from 'redux';
// import thunk from 'redux-thunk';

import CounterReducer from './CounterReducer';
import ScannerReducer from './ScannerReducer';

const AppReducers = combineReducers({
    CounterReducer,
    ScannerReducer
});

const rootReducer = (state,action) => {
    return AppReducers(state,action);
}

let store = createStore(rootReducer);

export default store;