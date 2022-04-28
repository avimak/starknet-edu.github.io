%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
# from starkware.starknet.common.syscalls import get_caller_address, get_block_number
from starkware.starknet.common.syscalls import get_block_number
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc721.library import (
    ERC721_name,
    ERC721_symbol,
    ERC721_balanceOf,
    ERC721_ownerOf,
    ERC721_getApproved,
    ERC721_isApprovedForAll,
    ERC721_tokenURI,
    ERC721_initializer,
    ERC721_approve,
    ERC721_setApprovalForAll,
    ERC721_transferFrom,
    ERC721_safeTransferFrom,
    ERC721_mint,
    ERC721_burn,
    ERC721_only_token_owner,
    ERC721_setTokenURI,
)

from openzeppelin.access.ownable import Ownable_initializer, Ownable_only_owner

from openzeppelin.introspection.ERC165 import ERC165_supports_interface

struct MintWindow:
    member mint_start : felt
    member mint_end : felt
end

@storage_var
func secret() -> (stored_secret : felt):
end

@storage_var
func mint_window() -> (window : MintWindow):
end

#
# Constructor
#

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    name : felt, symbol : felt, owner : felt, init_secret : felt
):
    ERC721_initializer(name, symbol)
    Ownable_initializer(owner)

    secret.write(init_secret)

    let (block_number) = get_block_number()
    mint_window.write(MintWindow(mint_start=block_number, mint_end=block_number + 60))

    return ()
end

#
# Getters
#

@view
func get_secret{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    curr_secret : felt
):
    let (curr_secret) = secret.read()

    return (curr_secret)
end

@view
func get_mint_window{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    mw : MintWindow
):
    let (mw) = mint_window.read()

    return (mw)
end

@view
func supportsInterface{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    interfaceId : felt
) -> (success : felt):
    let (success) = ERC165_supports_interface(interfaceId)
    return (success)
end

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    let (name) = ERC721_name()
    return (name)
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    let (symbol) = ERC721_symbol()
    return (symbol)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt) -> (
    balance : Uint256
):
    let (balance : Uint256) = ERC721_balanceOf(owner)
    return (balance)
end

@view
func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (owner : felt):
    let (owner : felt) = ERC721_ownerOf(tokenId)
    return (owner)
end

@view
func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (approved : felt):
    let (approved : felt) = ERC721_getApproved(tokenId)
    return (approved)
end

@view
func isApprovedForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, operator : felt
) -> (isApproved : felt):
    let (isApproved : felt) = ERC721_isApprovedForAll(owner, operator)
    return (isApproved)
end

@view
func tokenURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (tokenURI : felt):
    let (tokenURI : felt) = ERC721_tokenURI(tokenId)
    return (tokenURI)
end

#
# Externals
#

@external
func approve{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    to : felt, tokenId : Uint256
):
    ERC721_approve(to, tokenId)
    return ()
end

@external
func setApprovalForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    operator : felt, approved : felt
):
    ERC721_setApprovalForAll(operator, approved)
    return ()
end

@external
func transferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    from_ : felt, to : felt, tokenId : Uint256
):
    ERC721_transferFrom(from_, to, tokenId)
    return ()
end

@external
func safeTransferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    from_ : felt, to : felt, tokenId : Uint256, data_len : felt, data : felt*
):
    ERC721_safeTransferFrom(from_, to, tokenId, data_len, data)
    return ()
end

@external
func setTokenURI{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    tokenId : Uint256, tokenURI : felt
):
    Ownable_only_owner()
    ERC721_setTokenURI(tokenId, tokenURI)
    return ()
end

@external
func mint{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    to : felt, tokenId : Uint256
):
    Ownable_only_owner()
    ERC721_mint(to, tokenId)
    return ()
end

@external
func burn{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(tokenId : Uint256):
    ERC721_only_token_owner(tokenId)
    ERC721_burn(tokenId)
    return ()
end
