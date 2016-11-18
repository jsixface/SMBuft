//
//  i2c.swift
//  test
//
//  Created by Arumugam Jeganathan on 10/8/16.
//
//
#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import Foundation

internal let version = 2

public class I2CHardware
{
    
    let fd: CInt
    
    let I2C_SLAVE: UInt  = 0x0703
    let I2C_SMBUS : UInt =	0x0720	/* SMBus-level access */
    
    let I2C_SMBUS_READ : UInt8 = 1
    let I2C_SMBUS_WRITE	: UInt8  = 0
    
    let I2C_SMBUS_QUICK =         0
    let I2C_SMBUS_BYTE =          1
    let I2C_SMBUS_BYTE_DATA =     2
    let I2C_SMBUS_WORD_DATA =     3
    let I2C_SMBUS_PROC_CALL =     4
    let I2C_SMBUS_BLOCK_DATA =        5
    let I2C_SMBUS_I2C_BLOCK_BROKEN =  6
    let I2C_SMBUS_BLOCK_PROC_CALL =   7       /* SMBus 2.0 */
    let I2C_SMBUS_I2C_BLOCK_DATA =    8
    
    let I2C_SMBUS_BLOCK_MAX = 32  /* As specified in SMBus standard */
    let I2C_SMBUS_I2C_BLOCK_MAX = 32  /* Not specified but we use same structure */
    
    
    init(atAddress address :CInt) {
        let device :String
        if version == 1{
            device = "/dev/i2c-0"
        }
        else{
            device = "/dev/i2c-1"
        }
        errno = 0
        fd = open (device, O_RDWR)
        guard (fd > 0) else {
            print("Unable to open I2C device: \(device). Error: \(errno)")
            abort()
        }
        let ioFd = ioctl(fd, I2C_SLAVE, address)
        
        guard (ioFd >= 0) else
        {
            print("Unable to select device at \(address). Error: \(errno)")
            abort()
        }
    }
    
    
    struct i2c_smbus_ioctl_data
    {
        var read_write :UInt8
        var command :UInt8
        var size : Int //TODO check equivalent data type
        var data : UnsafeMutableRawPointer
    }
    
    func i2c_smbus_access ( rw: UInt8,  command:UInt8,  size:Int, data: UnsafeMutableRawPointer) -> CInt
    {
        var args = i2c_smbus_ioctl_data(read_write: rw, command: command, size: size, data: data)
        return ioctl (fd, I2C_SMBUS, &args)
    }
    
    func writeByteData ( reg: UInt8,  value : UInt8) -> CInt
    {
        var data = value & 0xFF;
        return i2c_smbus_access (rw: I2C_SMBUS_WRITE, command: reg, size: I2C_SMBUS_BYTE_DATA, data: &data)
    }
    
    func writeWordData ( reg: UInt8,  value: UInt16) -> CInt 
    {
        var data = value & 0xffff
        return i2c_smbus_access (rw: I2C_SMBUS_WRITE, command: reg, size: I2C_SMBUS_WORD_DATA, data: &data)
    }
    
    
    deinit {
        print("Closing down the file handler")
        close(fd)
    }
}
