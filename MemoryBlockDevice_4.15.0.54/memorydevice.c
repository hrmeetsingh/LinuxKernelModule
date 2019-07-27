#include <linux/fs.h>
#include <linux/genhd.h>
#include <linux/module.h>

#define MY_BLOCK_MINORS       1

/* 
*  ***************** WARNING *************** 
*  WIP - need to fix the crash while insmod'ing
*/

static struct my_block_dev {
    struct gendisk *gd;
} dev;


struct block_device_operations {
    int (*open) (struct block_device *, fmode_t);
    int (*release) (struct gendisk *, fmode_t);
    int (*locked_ioctl) (struct block_device *, fmode_t, unsigned,
                         unsigned long);
    int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
    int (*compat_ioctl) (struct block_device *, fmode_t, unsigned,
                         unsigned long);
    int (*direct_access) (struct block_device *, sector_t,
                          void **, unsigned long *);
    int (*media_changed) (struct gendisk *);
    int (*revalidate_disk) (struct gendisk *);
    int (*getgeo)(struct block_device *, struct hd_geometry *);
    struct module *owner;
};


static int my_block_open(struct block_device *bdev, fmode_t mode)
{
    printk(KERN_INFO "Opened device... ");
    return 0;
};

static int my_block_release(struct gendisk *gd, fmode_t mode)
{
    printk(KERN_INFO "Releasing device...");
    return 0;
};

struct block_device_operations my_block_ops = {
    .owner = THIS_MODULE,
    .open = my_block_open,
    .release = my_block_release
};

static int create_block_device(struct my_block_dev *dev)
{
    dev->gd = alloc_disk(MY_BLOCK_MINORS);
    add_disk(dev->gd);
    dev->gd->fops = &my_block_ops;
    dev->gd->private_data = dev;
    return 0;
};

static int my_block_init(void)
{
    printk(KERN_INFO "Device block initialized...");
    create_block_device(&dev);
    return 0;
};

static void delete_block_device(struct my_block_dev *dev)
{
    if (dev->gd)
        del_gendisk(dev->gd);
    printk(KERN_INFO "Deleting block device...");
};

static void my_block_exit(void)
{
    delete_block_device(&dev);
};


int init_module(void){
	my_block_init();
	return 0;
}

void cleanup_module(void){
	my_block_exit();
}

MODULE_LICENSE("GPL");
