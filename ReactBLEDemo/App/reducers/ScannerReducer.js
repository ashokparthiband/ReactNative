import * as Actions from './../actions/ActionTypes';

const ScannerReducer = (state = {
    scannedResultArray:[],
    isToggled:false,
    buttonTitle:"Scan"
},action) => {
    console.log("=========================== Scan Result"+action.scanResult);
    switch(action.type) {
        case Actions.START_SCAN:
            return Object.assign({},state,{
                isToggled:!state.isToggled,
                buttonTitle:"Stop"
            });
        case Actions.STOP_SCAN:
            return Object.assign({},state,{
                isToggled:!state.isToggled,
                buttonTitle:"Scan"
            });
        case Actions.ADD_SCAN_RESULT:
            return Object.assign({},state,{
               scannedResultArray:[...state.scannedResultArray,action.scanResult]
            });
        case Actions.UPDATE_SCAN_RESULT: {
            const updatedItems = state.scannedResultArray.map(item => {
                if(item.deviceUUID === action.scanResult.deviceUUID){
                  return { ...item, RSSI: action.scanResult.RSSI }
                }
                return item
              })
            return Object.assign({},state,{
               scannedResultArray:updatedItems
            });
        }    
        case Actions.REMOVE_SCAN_RESULT:
            return Object.assign({},state,{
                scannedResultArray:[]
            });
        default:
            return state;
        }
};

function searchDevice (device,array) {
    for (var i=0; i < array.length; i++) {
        if (array[i].deviceUUID == device.deviceUUID) {
            let scanResult = array[i];
            scanResult.RSSI = device.RSSI
            console.log(scanResult)
            break
        }
    }
}

export default ScannerReducer;