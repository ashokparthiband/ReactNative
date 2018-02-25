import React from 'react';
import { View, ListView, StyleSheet, Text ,TouchableHighlight,Button,titleStyle} from 'react-native';
import CustomListView from './../App/CustomListView';
import { StackNavigator } from 'react-navigation';

class Home extends React.Component<Props> {

    static navigationOptions = ({navigation}) => ({
      title: "Devices",
      headerTitleStyle:{
        fontSize:24,
        alignSelf:'center'
      },
      headerRight:
      <Button
        onPress={() => navigation.navigate("Scan", {screen: "ScanWindow"})}
        title = "Scan"
        color= "#000" >
      </Button>
      
    });

    render() {
      const { navigate } = this.props.navigation;
      return (
        <View style={styles.container}>
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

  export default Home;