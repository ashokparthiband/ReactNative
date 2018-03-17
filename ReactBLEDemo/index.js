import { AppRegistry } from 'react-native';
import React from 'react'
import App from './App';

import {Provider} from 'react-redux'
import store from './App/reducers/index'

const ReduxApp = () => (
  <Provider store={store}>
    <App />
  </Provider>
)

AppRegistry.registerComponent('ReactBLEDemo', () => ReduxApp);
