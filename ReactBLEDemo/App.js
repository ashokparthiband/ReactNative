/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View
} from 'react-native';

import Home from './Screens/Home'
import ScanWindow from './Screens/ScanWindow'
import { StackNavigator } from 'react-navigation';
import CustomListView from './App/CustomListView';
import NumberCounter from './App/NumberCounter';
import CounterAction from './App/actions/CounterAction';
import ScannerAction from './App/actions/ScannerAction'
import {Provider} from 'react-redux'
import store from './App/reducers/index'

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

// const counter = () => (
//     <Provider store = {store}>
//       <CounterAction/>
//     </Provider>
// );

const App = StackNavigator({
  Home: { screen: ScannerAction},
  Counter: {screen:CounterAction},
  Scan: { screen: ScanWindow}
})

// type Props = {};
// export default class App extends Component<Props> {
//   render() {
//     return (
//       <View style={styles.container}>
          
//         </View>
//     );
//   }
// }

 // headerRight:
      // <Button
      //   onPress={() => navigation.navigate("Scan", {screen: "ScanWindow"})}
      //   title = "Next"
      //   color= "#000" >
      // </Button>   

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#eff042',
    flex: 1,
    flexDirection: 'column',
  }
});

export default App;
