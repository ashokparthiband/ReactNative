import React from 'react';
import { View, ListView, StyleSheet, Text } from 'react-native';

class ScanWindow extends React.Component<Props> {

    static navigationOptions = {
        title: "Scan",
        headerTitleStyle:{
            fontSize:24,
            alignSelf:'center'
          },
      }

    render() {
      return (
        <View style={styles.container}></View>
      );
    }
  }

  const styles = StyleSheet.create({
    container: {
      backgroundColor: '#eff042',
      flex: 1,
      flexDirection: 'column',
    }
  });


  export default ScanWindow;