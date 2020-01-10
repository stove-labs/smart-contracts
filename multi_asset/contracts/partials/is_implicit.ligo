(* Converts the given key_hash into an address *)
function key_hash_to_address(const key_hash : key_hash) : address
    is address(implicit_account(key_hash))

(*
    Packs the given address into bytes, breaks it down and attempts 
    to reconstruct it as an implicit account.

    Returns True if the given address is an implicit account.
*)
function is_implicit(const addr : address) : bool
    is block {
        // (* Break down the address into bytes *)
        const packed_address : bytes = bytes_pack(addr);
        const sliced_address_bytes : bytes = bytes_slice(7n, 21n, packed_address);
        (* Attempt to reconstruct the address as an implicit account / key_hash *)
        const check_bytes_prefix : bytes = ("050A00000015" : bytes);
        const concatenated_check_bytes : bytes = bytes_concat(check_bytes_prefix, sliced_address_bytes);
        const unpacked_key_hash : option(key_hash) = (bytes_unpack(concatenated_check_bytes) : option(key_hash));
        
        const is_implicit : bool = case unpacked_key_hash of
            | Some(key_hash) -> addr = key_hash_to_address(key_hash)
            | None -> False
        end        
    } with is_implicit