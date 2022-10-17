
import torch
import torch.autograd as autograd
import torch.nn as nn
import torch.optim as optim

import os
import time
import paths

from datetime import datetime
from dataset import BlendshapeDataset
from models import LSTMNvidiaNet


# =========================================================
# -- Create model -----------------------------------------
# =========================================================

model = LSTMNvidiaNet(num_blendshapes=n_blendshape)
criterion = nn.MSELoss() #??.cuda()
optimizer = optim.Adam(model.parameters(), lr=learning_rate)

if torch.cuda.is_available():
    model = model.cuda()
    print('Running with CUDA')
else:
    print('-'*10 + ' NO CUDA! ' + '-'*10)


# =========================================================
# -- Prepare data loaders ---------------------------------
# =========================================================

# Training
train_ds = BlendshapeDataset(
    feature_file=os.path.join(train_path, combined_feature_file),
    target_file=os.path.join(train_path, combined_blendshapes_file)
)
train_loader = torch.utils.data.DataLoader(train_ds, shuffle=True, batch_size=batch_size, num_workers=2)

# Validation
val_ds = BlendshapeDataset(
    feature_file=os.path.join(val_path, combined_feature_file),
    target_file=os.path.join(val_path, combined_blendshapes_file),
)
val_loader = torch.utils.data.DataLoader(val_ds, shuffle=False, batch_size=batch_size, num_workers=2)


# =========================================================
# -- Train ------------------------------------------------
# =========================================================

print('------------\n Training begin at %s' % datetime.now())

n_train = len(train_loader)
n_val = len(val_loader)

for epoch in range(epochs):
    start_time = time.time()

    # Train
    model.train()
    train_loss = 0.
    for i, (input, target) in enumerate(train_loader):
        
        # Prepare (TODO: WTF !?)
        input_var = autograd.Variable(input.float())
        if torch.cuda.is_available():
            target = target.cuda(non_blocking=True)
            input_var = input_var.cuda()
        
        target_var = autograd.Variable(target.float())

        # Compute output
        output = model(input_var)
        loss = criterion(output, target_var)
        train_loss += loss * 100

        # Back propagate
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        # Log progress
        should_log = print_freq != -1 and i % print_freq == 0
        if should_log:
            print('Training -- epoch: {:03} | iteration: {}/{} | loss: {:.6f} \r'
                    .format(epoch + 1, i, n_train, loss.data[0]))

    train_loss /= len(train_loader)

    # Validate
    model.eval()
    eval_loss = 0.
    with torch.no_grad():
        for input, target in val_loader:
            
            # Prepare (TODO: WTF !?)
            input_var = autograd.Variable(input.float())
            if torch.cuda.is_available():
                target = target.cuda(non_blocking=True)
                input_var = input_var.cuda()
            
            target_var = autograd.Variable(target.float())

            # Compute output
            output = model(input_var)
            loss = criterion(output, target_var)
            eval_loss += loss * 100

    eval_loss /= len(val_loader)

    # Log epoch progress
    past_time = time.time() - start_time
    print('epoch: {:03} | train_loss: {:.6f} | eval_loss: {:.6f} | {:.4f} sec/epoch \r'
        .format(epoch+1, train_loss, eval_loss, past_time))

    # Save checkpoint models
    is_best = eval_loss < best_loss
    if is_best:
        best_loss = min(eval_loss, best_loss)
        save_checkpoint(epoch=epoch, model=model, eval_loss=best_loss, is_best=True)

    if (epoch + 1) % checkpoint_freq == 0:
        save_checkpoint(epoch=epoch, model=model, eval_loss=eval_loss)

print('Training finished at %s' % datetime.now())
