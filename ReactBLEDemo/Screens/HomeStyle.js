import React from 'react';
import { StyleSheet} from 'react-native';

const styles = StyleSheet.create({
    container: {
      backgroundColor: '#eff0f2',
      flex: 1,
      flexDirection: 'column',
      // justifyContent: 'center',
    },
    container1: {
      backgroundColor: '#eff0f2',
      flexDirection: 'row',
      height:40,
      alignItems: 'center',
      justifyContent:'space-around'
    },
    containerListView: {
      flex: 1,
      backgroundColor:'white'
    },
    text:{
      fontSize: 30,
      textAlign: 'center'
    },
    titleView:{
      marginTop: 30,
      backgroundColor:'#eff0f2'
    },
    button: {
      marginBottom: 0,
      fontSize:20,
      alignItems: 'center',
      height:40
    },
    buttonText: {
      padding: 20,
      color: 'white'
    },
    actionButton: {
      padding:10,
      alignItems: 'center',
    }
  });

  export default styles;