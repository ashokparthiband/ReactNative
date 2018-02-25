import React from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';

const styles = StyleSheet.create({
    container: {
      flex: 1,
      padding: 12,
      flexDirection: 'row',
      alignItems: 'center',
      height:60
    },
    text: {
      marginLeft: 12,
      fontSize: 16,
    },
    text1: {
        marginLeft: 12,
        fontSize: 12,
        top: 5,
      },
    photo: {
      height: 40,
      width: 40,
      borderRadius: 20,
    },
    
  });

  const Row = (props) => (
    <View style={styles.container}>
      <Image source={(require('./Images/bulbIcon.png'))} style={styles.photo}/>
      <View style={{flex: 1,flexDirection: 'column'}}>
        <Text style={styles.text}>
            {`${props.deviceName}`}
        </Text>
        <Text style={styles.text1}>
            {`${props.deviceUUID}`}
        </Text>
      </View>
    </View>
  );
  
  export default Row;
   