
def assert_training_stage(stage: str) -> None:
    if type not in ['train', 'val', 'test']:
        raise ValueError(f"training stage type should be 'train', 'val', 'test' ('{type}' given)")

def save_features(features: np.array, type: str = 'train') -> None:
    assert_training_stage(type)
    file_path = os.path.join(combine_path, type, combined_feature_file)
    np.save(file_path, features)

def save_blendshapes(blendshapes: np.array, type: str = 'train') -> None:
    assert_training_stage(type)
    file_path = os.path.join(combine_path, type, combined_blendshapes_file)
    np.savetxt(file_path, blendshapes, fmt='%.8f')

def save_checkpoint(epoch: int, model: nn.Module, eval_loss: float, is_best: bool = False):
    torch.save({
        'epoch': epoch + 1,
        'state_dict': model.state_dict(),
        'eval_loss': eval_loss,
        },
        paths.checkpoint_file(epoch=epoch, is_best=is_best)
    )