import os

__all__ = ['feature_file', 'blendshape_file', 'wav_file']

def _get_file_name(path: str) -> str:
    pathname, extension = os.path.splitext(path)
    return pathname.split('/')[-1]

def feature_file(base_name: str) -> str:
    return _get_file_name(base_name) + '-lpc.npy'

def blendshape_file(base_name: str) -> str:
    return _get_file_name(base_name) + '.json'

def wav_file(base_name: str) -> str:
    return _get_file_name(base_name) + '.wav'
