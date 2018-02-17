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
  View,ScrollView
} from 'react-native';

// import styles from './Styles/styles'

var styles = require('./Styles/styles')

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
        <View style = {{alignItems:'center',justifyContent:'center',height:60,backgroundColor:'#edf1f2'}}>
          <Text style = {{fontSize:40,fontWeight:"bold",color:'#386268',textShadowRadius:10}}>My Home</Text>  
        </View>
        <View style = {{alignItems:'center',justifyContent:'center',flex:2}}>
        <ScrollView >
          <Text style={{fontSize:50}}>Scroll me plz</Text>
          <View style= {{backgroundColor:"powderblue",height:60}}/>
          <View style= {{backgroundColor:"skyblue",height:60}}/>
          <View style= {{backgroundColor:"steelblue",height:60}}/>

          <Text style={{fontSize:50}}>If you like</Text>
          <View style= {{backgroundColor:"powderblue",height:60}}/>
          <View style= {{backgroundColor:"skyblue",height:60}}/>
          <View style= {{backgroundColor:"steelblue",height:60}}/>

          <Text style={{fontSize:50}}>Scrolling down</Text>
          <View style= {{backgroundColor:"powderblue",height:60}}/>
          <View style= {{backgroundColor:"skyblue",height:60}}/>
          <View style= {{backgroundColor:"steelblue",height:60}}/>

          <Text style={{fontSize:50}}>What's the best</Text>
          <View style= {{backgroundColor:"powderblue",height:60}}/>
          <View style= {{backgroundColor:"skyblue",height:60}}/>
          <View style= {{backgroundColor:"steelblue",height:60}}/>

          <Text style={{fontSize:50}}>Framework around?</Text>
          <View style= {{backgroundColor:"powderblue",height:60}}/>
          <View style= {{backgroundColor:"skyblue",height:60}}/>
          <View style= {{backgroundColor:"steelblue",height:60}}/>
          <Text style={{fontSize:80}}>React Native</Text>
        </ScrollView>
        </View>
      </View>
    );
  }
}




{/* <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
      </View> */}