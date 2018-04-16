import React from 'react';
import { View, ListView, StyleSheet, Text,TouchableHighlight, ScrollView } from 'react-native';

import {
  Cell,
  Section,
  TableView,
} from 'react-native-tableview-simple';


class HardwareDetails extends React.Component {
    constructor(props) {
      super(props);
    }

    static navigationOptions = ({navigation}) => ({
      title: "Device Info",
      headerTitleStyle:{
        fontSize:24,
        alignSelf:'center'
      },
    });

    render() {
      return (
        <View style={styles.container}>
           <ScrollView style={styles.stage}>
            <TableView>
              <Section header="Basic Info">
                <Cell
                  cellStyle="Subtitle"
                  title="Name"
                  detail="Heart Rate Moniter"
                />
                <Cell
                  cellStyle="Subtitle"
                  title="Hardware Version"
                  detail="20.25.30"
                />
                <Cell
                  cellStyle="Subtitle"
                  title="Software Version"
                  detail="0.0.8"
                />
                <Cell
                  cellStyle="Subtitle"
                  title="Firmware Version"
                  detail="5.9.8"
                />
            </Section>
            <Section header="Heart Rate Info">
                <Cell
                  cellStyle="Subtitle"
                  title="Sensor Location"
                  detail="Chest"
                />
                <Cell
                  cellStyle="Subtitle"
                  title="Heart Point"
                  // detail="0.0.8"
                />
                <Cell
                  cellStyle="Subtitle"
                  title="Heart Rate Mesurement"
                  detail="102"
                />
            </Section>
            </TableView> 
           </ScrollView>
        </View>
      );
    }
}

const styles = StyleSheet.create({
    container: {
      flex: 1,
      backgroundColor:'white'
    },
    stage: {
      backgroundColor: '#EFEFF4',
    },
});

export default HardwareDetails;