#!/usr/bin/python3
#OpenHarmony linux-5.10 patch
import os

patchlist = [
# '6',
# '11',
# '10',
# '17',
# '18',
# '28',
# '35',
# '40',
# '24',
# '45',
# '44',
# '48',
# '43',
# '52',
# '56',
# '49',
# '57',
# '55',
# '54',
# '64',
# '59',
# '67',
# '66',
# '58',
# '65',
# '68',
# '60',
# '62',
# '70',
# '72',
# '69',
# '73',
# '53',
# '77',
# '75',
# '76',
# '81',
# '82',
# '79',
# '84',
# '74',
# '87',
# '88',
# '91',
# '90',
# '92',
# '89',
# '98',
# '99',
# '95',
# '106',
# '112',
# '117',
# '128',
# '138',
# '183',
# '184',
# '185',
# '179',
# '182',
# '186',
# '187',
# '192',
# '197',
# '200',
# '170',
# '195',
# '229',
# '231',
# '234',
# '232',
# '246',
# '243',
# '239',
# '230',
# '254',
# '266',
# '261',
# '265',
# '263',
# '252',
# '271',
# '273',
# '280',
# '282',
'286',
'278'
]

#git fetch https://gitee.com/openharmony/kernel_linux_5.10.git pull/138/head:pr_138
#https://gitee.com/openharmony/kernel_linux_5.10/pulls/138.diff
basepath = '/home/diemit/OpenHarmony/device/board/oneplus/fajita/patches/kernel-5.10'
baseurl = 'https://gitee.com/openharmony/kernel_linux_5.10/pulls'
os.popen(f'mkdir -p {basepath}')
os.chdir(basepath)
for patchid in patchlist:
    filename = f'{basepath}/{patchid}.diff'
    if not os.path.exists(filename):
        print(f'{patchid}.patch 补丁文件不存在,下载补丁保存为{filename}')
        result = os.popen(f'wget {baseurl}/{patchid}.diff')
        for temp in result.readlines():
            print(temp)


#git apply /home/diemit/OpenHarmony/device/board/oneplus/fajita/patches/kernel-5.10/1.diff
#git apply --stat patchfile
#git apply --check patchfile
os.chdir('/home/diemit/OpenHarmony/kernel/linux/linux-rpi-5.10')
for patchid in patchlist:
    patchfile = f'{basepath}/{patchid}.diff'
    result = os.popen(f'git apply --check {patchfile}')
    print(f'检查补丁{patchid} : git apply {patchfile}')
    for temp in result.readlines():
        print(temp)
