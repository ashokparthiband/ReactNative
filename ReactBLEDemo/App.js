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
import CustomListView from './App/CustomListView';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {
  render() {
    return (
      <View style={styles.container}>
        <View style={styles.titleView}><Text style={styles.text}>Devices</Text></View>
        <CustomListView></CustomListView>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#eff0f2',
    flex: 1,
    flexDirection: 'column',
  },
  text:{
    fontSize: 30,
    textAlign: 'center'
  },
  titleView:{
    marginTop: 30,
    backgroundColor:'#eff0f2'
  }
});
