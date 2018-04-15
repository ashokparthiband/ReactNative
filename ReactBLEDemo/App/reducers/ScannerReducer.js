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
                buttonTitle:"Scan"
            });
        case Actions.STOP_SCAN:
            return Object.assign({},state,{
                isToggled:!state.isToggled,
                buttonTitle:"Stop"
            });
        case Actions.ADD_SCAN_RESULT:
            return Object.assign({},state,{
               scannedResultArray:[...state.scannedResultArray,action.scanResult]
            });
        case Actions.REMOVE_SCAN_RESULT:
            return Object.assign({},state,{
                scannedResultArray:[]
            });
        default:
            return state;
        }
};

export default ScannerReducer;