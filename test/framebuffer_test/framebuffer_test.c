#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

// 宏定义
#define FBDEVICE	"/dev/graphics/fb0"

#define WHITE		0xffffffff			// test ok
#define BLACK		0x00000000
#define RED			0xffff0000
#define GREEN		0xff00ff00			// test ok
#define BLUE		0xff0000ff			

#define GREENP		0x0000ff00			// 一样，说明前2个ff透明位不起作用
// 函数声明
void draw_back(unsigned int width, unsigned int height, unsigned int color);
void draw_line(unsigned int color);
// 全局变量
unsigned int *pfb = NULL;
unsigned int gwidth;
unsigned int gheight;

int main(void)
{
	int fd = -1, ret = -1;
	
	
	struct fb_fix_screeninfo finfo = {0};
	struct fb_var_screeninfo vinfo = {0};
	
	// 第1步：打开设备
	fd = open(FBDEVICE, O_RDWR);

	if (fd < 0)
	{
		perror("open");
		return -1;
	}
	printf("open %s success.\n", FBDEVICE);
	
	// 第2步：获取设备的硬件信息
	ret = ioctl(fd, FBIOGET_FSCREENINFO, &finfo);
	if (ret < 0)
	{
		perror("ioctl");
		return -1;
	}
	printf("smem_start = 0x%lx, smem_len = %u.\n", finfo.smem_start, finfo.smem_len);
	
	ret = ioctl(fd, FBIOGET_VSCREENINFO, &vinfo);
	if (ret < 0)
	{
		perror("ioctl");
		return -1;
	}
	printf("xres = %u, yres = %u.\n", vinfo.xres, vinfo.yres);
	printf("xres_virtual = %u, yres_virtual = %u.\n", vinfo.xres_virtual, vinfo.yres_virtual);
	printf("bpp = %u.\n", vinfo.bits_per_pixel);
	
	// 第3步：进行mmap
	unsigned long len = vinfo.xres_virtual * vinfo.yres_virtual * vinfo.bits_per_pixel / 8;
	printf("len = %ld\n", len);
	pfb = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (NULL == pfb)
	{
		perror("mmap");
		return -1;
	}
	printf("pfb = %p.\n", pfb);

	close(fd);

	gwidth = vinfo.xres_virtual;
	gheight = vinfo.yres_virtual;
	
    //第4步：填充framebuffer
	draw_back(gwidth, gheight, WHITE);
    sleep(2);
    draw_back(gwidth, gheight, RED);
    sleep(2);
    draw_back(gwidth, gheight, GREEN);
    sleep(2);
    draw_back(gwidth, gheight, BLUE);
    sleep(2);
    draw_back(gwidth, gheight, BLACK);
	// draw_line(RED);
	
	return 0;
}
void draw_back(unsigned int width, unsigned int height, unsigned int color)
{
	unsigned int x, y;
	
	for (y=0; y<height; y++)
	{
		for (x=0; x<width; x++)
		{
			*(pfb + y * gwidth + x) = color;
		}
	}
}
void draw_line(unsigned int color)
{
	unsigned int x;
	
	for (x=50; x<600; x++)
	{
		*(pfb + 200 * gwidth + x) = color;
	}
}
