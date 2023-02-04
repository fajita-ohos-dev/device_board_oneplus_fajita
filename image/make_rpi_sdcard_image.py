#!/usr/bin/env python3
import sys
import re
import os
import os.path
import subprocess
from optparse import OptionParser

def str2bytes(s):
    m = re.match(r'^(\d+)([KMGkmg])?$', s)
    assert(m)
    n = int(m.group(1))
    u = m.group(2)
    e = 0
    if u:
        e = {
            'K': 10,
            'M': 20,
            'G': 30,
        }[u.upper()]
    return n << e

def make_userdata_image(userdata, size):
    with open(userdata, 'wb') as writer:
        writer.truncate(size)
    os.system(F'mkfs.ext4 -L userdata {userdata}')

def copy_partition_to_image(image_writer, partition, offset, partsize):
    name = os.path.basename(partition)
    size_mb = (partsize+1024*1024-1) // (1024*1024)
    print(F'Add image to firmwarm: {name:<{16}} {size_mb}MB')
    bs = 16*1024
    with open(partition, 'rb') as reader:
        image_writer.seek(offset)
        copyed = 0
        while True:
            data = reader.read(bs)
            if len(data) == 0:
                break
            rlen = len(data)
            assert(rlen + copyed <= partsize)
            # Try to make a sparse file to save your disk
            # To disable this feature, replace condition in next line to True
            if re.search(rb'[^\0]', data):
                image_writer.write(data)
            else:
                image_writer.seek(rlen, 1)
            copyed += rlen

def make_raspberry_image(output, userdata_size, partition_images):
    try:
        os.unlink(output)
    except FileNotFoundError:
        pass
    if userdata_size != None:
        make_userdata_image(partition_images[-1], userdata_size)
    partition_sizes = tuple((os.stat(img).st_size+1023)//1024 for img in partition_images)
    p1, p2, p3, p4 = partition_sizes
    output_tmp = output + '.tmp'

    ptpath=os.path.abspath(os.path.dirname(__file__))


    ptgen_cmd = F'{ptpath}/ptgen -o {output_tmp} -l 1024 -s 63 -h 256 -a 1 -t 0c -p {p1} -t 83 -p {p2} -p {p3} -p {p4}'
    ptgen_result = subprocess.run(ptgen_cmd, shell=True, check=True, stdout=subprocess.PIPE).stdout
    ptgen_result = tuple(int(n) for n in ptgen_result.decode().strip().split('\n'))
    ptgen_result = tuple((ptgen_result[i], ptgen_result[i+1]) for i in range(0, len(ptgen_result), 2))
    with open(output_tmp, 'rb+') as writer:
        for i in range(4):
            copy_partition_to_image(writer, partition_images[i], *ptgen_result[i])
        writer.truncate(writer.tell())
    os.rename(output_tmp, output)

parser = OptionParser()
parser.add_option('-o', '--output', help='output image')
parser.add_option('-u', '--userdata', help='userdata size')
(options, args) = parser.parse_args()
if options.output == None:
    parser.error(F'missing parameter: output')

if len(args) != 4:
    parser.error(F'need 4 arguments to specify boot/system/vendor/userdata image path')
userdata_size = None
if options.userdata:
    userdata_size = str2bytes(options.userdata)
make_raspberry_image(options.output, userdata_size, args)

