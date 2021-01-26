from PIL import Image
import os
import numpy as np
from scipy import ndimage


def to_grey(img):
    if img.ndim == 2:
        return img.astype(np.float) / 255.0

    im_grey = np.zeros((img.shape[0],img.shape[1])).astype(np.float)
    im_grey = (img[...,0] * 0.3 + img[...,1] * 0.6 + img[...,2] * 0.1)
    return im_grey

def compute_normal_map(sobel_x, sobel_y, intensity=1):

    width = sobel_x.shape[1]
    height = sobel_x.shape[0]
    max_x = np.max(sobel_x)
    max_y = np.max(sobel_y)

    max_value = max_x

    if max_y > max_x:
        max_value = max_y

    normal_map = np.zeros((height, width, 3), dtype=np.float32)

    intensity = 1 / intensity

    strength = max_value / (max_value * intensity)

    normal_map[..., 0] = sobel_x / max_value
    normal_map[..., 1] = sobel_y / max_value
    normal_map[..., 2] = 1 / strength

    norm = np.sqrt(np.power(normal_map[..., 0], 2) + np.power(normal_map[..., 1], 2) + np.power(normal_map[..., 2], 2))

    normal_map[..., 0] /= norm
    normal_map[..., 1] /= norm
    normal_map[..., 2] /= norm

    normal_map *= 0.5
    normal_map += 0.5

    return normal_map

bad_suffix = "_2", "_dead", "_normals", "_normal"

dds_imgs = [f for f in sorted(os.listdir()) if f.endswith('.dds')]
for dds in dds_imgs:
    convert_me = True
    for suffix in bad_suffix:
        if dds.lower().endswith(suffix + ".dds"):
            convert_me = False
            break

    if not convert_me:
        continue

    if dds.lower().endswith("2.dds") and os.path.exists(dds.lower()[:-5] + "1.dds"):
        continue

    png = dds[:-4] + "_normals.png"
    print("Converting " + dds + " -> " + png)
    try:
        img = Image.open(dds)
        npimg = to_grey(np.array(img)[:,:,:3])
        sobel_x, sobel_y = ndimage.sobel(npimg, axis=0), ndimage.sobel(npimg, axis=1)
        normal_map = compute_normal_map(sobel_x, sobel_y)
        normal_map = normal_map[::-1, :, :]
        img = Image.fromarray((normal_map * 255).astype(np.uint8))
        img.save(png)
    except:
        print("\tFAILED")
