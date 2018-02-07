#include "stdio.h"
#include "usbstk5515.h"
extern Int16 AIC3204_rset( Uint16 regnum, Uint16 regval);

Int16 aic3204_init( )
{
     
    /* Configure Serial Bus */
    SYS_EXBUSSEL |= 0x0100;  // Configure Serial bus 0 for I2S0
    
    /* Configure AIC3204 */
    AIC3204_rset( 0, 0 );      // Select page 0
    AIC3204_rset( 1, 1 );      // Reset codec
    AIC3204_rset( 0, 1 );      // Point to page 1
    AIC3204_rset( 1, 8 );      // Disable crude AVDD generation from DVDD
    AIC3204_rset( 2, 1 );      // Enable Analog Blocks, use LDO power
    AIC3204_rset( 61, 0x00 );
    AIC3204_rset( 3, 0x00 );
    AIC3204_rset( 4, 0x00 );
    AIC3204_rset( 0, 0 );
    AIC3204_rset( 28, 0x00 );  // Data ofset = 0  
    AIC3204_rset( 27, 0x2d );  // BCLK and WCLK is set as o/p to AIC3204(Master)    
    
    /* PLL and Clocks config and Power Up  */
    AIC3204_rset( 4, 3 );      // PLL setting: PLLCLK <- MCLK, CODEC_CLKIN <-PLL CLK, PLL = 12MHz 
 	AIC3204_rset( 5, 0x91 );   // PLL setting: Power up PLL, P=1 and R=1
    AIC3204_rset( 6, 0x07 );   // PLL setting: J=7
    AIC3204_rset( 7, 0x02 );   // PLL setting: HI_BYTE(D)
    AIC3204_rset( 8, 0x30 );   // PLL setting: LO_BYTE(D)
    AIC3204_rset( 11, 0x85 );  // Power up NDAC and set NDAC value to 5                               // BCLK=DAC_CLK/N =(12288000/8) = 1.536MHz = 32*fs
    AIC3204_rset( 12, 0x83 );  // Power up MDAC and set MDAC value to 2   
    AIC3204_rset( 13, 0 );     // Hi_Byte(DOSR) for DOSR = 128 decimal or 0x0080 DAC oversamppling
    AIC3204_rset( 14, 0x80 );  // Lo_Byte(DOSR) for DOSR = 128 decimal or 0x0080
    AIC3204_rset( 20, 0x80 );  // AOSR for AOSR = 128 decimal or 0x0080 for decimation filters 1 to 6
    AIC3204_rset( 30, 0x88 );  // For 32 bit clocks per frame in Master mode ONLY  
	AIC3204_rset( 18, 0x88 );  // Power up NADC and set NADC value to 8
    AIC3204_rset( 19, 0x82 );  // Power up MADC and set MADC value to 2
    /* DAC ROUTING and Power Up */
    AIC3204_rset( 0, 1 );      // Select page 1
    AIC3204_rset( 0x0c, 8 );   // LDAC AFIR routed to HPL
    AIC3204_rset( 0x0d, 8 );   // RDAC AFIR routed to HPR
    AIC3204_rset( 0, 0 );      // Select page 0
    AIC3204_rset( 64, 2 );     // Left vol=right vol
    AIC3204_rset( 65, 0 );     // Left DAC gain to 0dB VOL; Right tracks Left
    AIC3204_rset( 63, 0xd4 );  // Power up left,right data paths and set channel
    AIC3204_rset( 0, 1 );      // Select page 1
    AIC3204_rset( 0x10, 10 );  // Unmute HPL , 10dB gain
    AIC3204_rset( 0x11, 10 );  // Unmute HPR , 10dB gain
    AIC3204_rset( 9, 0x30 );   // Power up HPL,HPR
    AIC3204_rset( 0, 0 );      // Select page 0
    USBSTK5515_wait( 100 );    // wait
    /* ADC ROUTING and Power Up */
    AIC3204_rset( 0, 1 );      // Select page 1
    AIC3204_rset( 0x34, 0x30 );// STEREO 1 Jack
		                       // IN2_L to LADC_P through 40 kohm
    AIC3204_rset( 0x37, 0x30 );// IN2_R to RADC_P through 40 kohmm
    AIC3204_rset( 0x36, 3 );   // CM_1 (common mode) to LADC_M through 40 kohm
    AIC3204_rset( 0x39, 0xc0 );// CM_1 (common mode) to RADC_M through 40 kohm
    AIC3204_rset( 0x3b, 0 );   // MIC_PGA_L unmute
    AIC3204_rset( 0x3c, 0 );   // MIC_PGA_R unmute
    AIC3204_rset( 0, 0 );      // Select page 0
    AIC3204_rset( 0x51, 0xc0 );// Powerup Left and Right ADC
    AIC3204_rset( 0x52, 0 );   // Unmute Left and Right ADC    
    AIC3204_rset( 0, 0 );    
    USBSTK5515_wait( 100 );  // Wait
    /* I2S settings (startup) */
    I2S0_SRGR = 0x0;     
    I2S0_CR = 0x8010;    // 16-bit word, slave, enable I2C
    I2S0_ICMR = 0x3f;    // Enable interrupts
    /* start input output */
    return 0;
    
}
