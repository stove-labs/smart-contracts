(*
    Usage:
    const a : nat = get_with_default_nat((None : option(nat)), 3n); // 3n
    const b : nat = get_with_default_nat(Some(5n), 3n); // 5n
*)
function get_with_default_nat(const option : option(nat); const default : nat) : nat 
    is case option of 
        | Some(value) -> value
        | None -> default
    end