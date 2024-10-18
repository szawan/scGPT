import torch
from flash_attn.flash_attn_interface import flash_attn_unpadded_func

# Dummy input tensors for testing
query = torch.randn(10, 16, 64, device='cuda', requires_grad=True)
key = torch.randn(10, 16, 64, device='cuda', requires_grad=True)
value = torch.randn(10, 16, 64, device='cuda', requires_grad=True)
cu_seqlens_q = torch.tensor([0, 10], dtype=torch.int32, device='cuda')
cu_seqlens_k = torch.tensor([0, 10], dtype=torch.int32, device='cuda')
max_s = 10

# Call FlashAttention function
output = flash_attn_unpadded_func(query, key, value, cu_seqlens_q, cu_seqlens_k, max_s)

print("FlashAttention output:", output)