import {combineReducers,createStore} from 'redux';

import CounterReducer from './CounterReducer'

const AppReducers = combineReducers({
    CounterReducer,
});

const rootReducer = (state,action) => {
    return AppReducers(state,action);
}

let store = createStore(rootReducer);

export default store;