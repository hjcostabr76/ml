import torch
import torch.autograd as autograd

import os
import time
import numpy as np

from dataset import BlendshapeDataset
from models import LSTMNvidiaNet

# =========================================================
# -- Load model -------------------------------------------
# =========================================================

model = LSTMNvidiaNet(num_blendshapes = n_blendshape)
checkpoint = torch.load(os.path.join(checkpoint_path, ckp))

print("=> loading checkpoint '{}'".format(ckp))
print("model epoch {} loss: {}".format(checkpoint['epoch'], checkpoint['eval_loss']))

model.load_state_dict(checkpoint['state_dict'])

if torch.cuda.is_available():
    model = model.cuda()
    print('cuda')
else:
    print('-'*10 + '!! NO CUDA !!' + '-'*10)

# =========================================================
# -- Prepare data loaders ---------------------------------
# =========================================================

test_ds = BlendshapeDataset(
    feature_file=os.path.join(test_path, feature_file),
    target_file=os.path.join(test_path, blend_shape_file)
)
test_loader = torch.utils.data.DataLoader(test_ds, batch_size=batch_size, shuffle=False, num_workers=2)

# =========================================================
# -- Test -------------------------------------------------
# =========================================================

model.eval()

start_time = time.time()
with torch.no_grad():
    for i, (input, _) in enumerate(test_loader):
        
        input_var = autograd.Variable(input.float())
        if torch.cuda.is_available():
            input_var = input_var.cuda()

        output = model(input_var)

        if i == 0:
            output_cat = output.data
        else:
            output_cat = torch.cat((output_cat, output.data), 0)

output_cat = output_cat.cpu().numpy() * 100.0
with open(result_file, 'wb') as f:
    np.savetxt(f, output_cat, fmt='%.6f')

past_time = time.time() - start_time
print("Test finished in {:.4f} sec! Saved in {}".format(past_time, result_file))