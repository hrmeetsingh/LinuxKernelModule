#include <linux/fs.h>
#include <linux/module.h>

#define SUCCESS 	0
#define MY_BLOCK_MAJOR           240
#define MY_BLKDEV_NAME          "mybdev"



static int my_block_init(void)
{
    int status;

    status = register_blkdev(MY_BLOCK_MAJOR, MY_BLKDEV_NAME);
    if (status < 0) {
             printk(KERN_ERR "unable to register mybdev block device\n");
             return -EBUSY;
     }
    printk(KERN_INFO "Registered the block device driver %s at major %d \n", MY_BLKDEV_NAME, MY_BLOCK_MAJOR);
    return SUCCESS;

}

static void my_block_exit(void)
{

     unregister_blkdev(MY_BLOCK_MAJOR, MY_BLKDEV_NAME);
     printk(KERN_INFO "Unregistering the device driver now \n");
}

int init_module(void){
	my_block_init();
	return SUCCESS;
}

void cleanup_module(void){
	my_block_exit();
}

MODULE_LICENSE("GPL");
