(* 
    This error code is throw if the incoming transaction is attempting 
    to transfer any tez (amount > 0) to the current contract 
*)
const no_incoming_tez_allowed : string = "1000";
