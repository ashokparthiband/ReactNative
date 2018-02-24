import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import CustomListView from './App/CustomListView';


export default class App extends React.Component {
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
