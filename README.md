# boiler_info

## RaspberryPi - snímač teploty TTY a I2C

```
sudo apt-get update
sudo apt-get install
```

## Povolit I2C a 1-wire v kernelu
```
sudo raspi-config
       => Interfacing options -> I2C
       => Interfacing options -> 1-wire
```

## I2C

```
sudo apt-get install -y python-smbus
sudo apt-get install -y i2c-tools
```

## OWFS (one-wire file system)
```
sudo mkdir /mnt/1wire
sudo apt-get install owfs
sudo apt-get install owfs-doc
sudo apt-get install ow-shell
sudo apt-get install python-ow
```

Ověříme dostupnost 1-wire kontroleru (bus master) na I2C sběrnici.

```
$ i2cdetect -l
i2c-1 i2c bcm2835 (i2c@7e804000) I2C adapter
```

Nyní je potřeba editovat /etc/owfs.conf :
Zakomentujte (přidejte před ní #) řádku:
server: FAKE = DS18S20,DS2405
a přidejte následující řádky:
device = /dev/i2c-1
mountpoint = /mnt/1wire
Celsius
allow_other
error_print = 0
error_level = 0

Dále editujte /etc/fuse.conf – odkomentujte řádku
user_allow_other

Teď by bylo dobré restartovat. Chvilku počkáme, než RPi naběhne… a pak ...

Zkusíme vypsat obsah owfs:
pi@raspberrypi ~ $ owdir
/28.9614C2030000
/bus.0
/uncached
/settings
/system
/statistics
/structure
/simultaneous
/alarm
Výpis „owdir“ ukazuje strukturu objektů v owfs. Objekt „/28.9614C2030000“ reprezentuje teplotní čidlo; kdyby bylo připojeno více čidel, měly by obdobná jména. Objekt „/bus.0“ je 1-wire sběrnice; kdyby bylo více sběrnic (např. při použití čipu DS2482-800), bylo by zde více záznamů „/bus.#“ .
Objekty jsou uloženy stromově – je možné se dívat i na další úrovně. Třeba na detaily čidla:
pi@raspberrypi ~ $ owdir /28.9614C2030000
/28.9614C2030000/address
/28.9614C2030000/alias
/28.9614C2030000/crc8
/28.9614C2030000/errata
/28.9614C2030000/family
/28.9614C2030000/fasttemp
/28.9614C2030000/id
/28.9614C2030000/locator
/28.9614C2030000/power
/28.9614C2030000/r_address
/28.9614C2030000/r_id
/28.9614C2030000/r_locator
/28.9614C2030000/temperature
/28.9614C2030000/temperature10
/28.9614C2030000/temperature11
/28.9614C2030000/temperature12
/28.9614C2030000/temperature9
/28.9614C2030000/temphigh
/28.9614C2030000/templow
/28.9614C2030000/type

Pro čtení dat z jednotlivých souborů je k dispozici příkaz owread. Můžeme se tedy zeptat třeba na typ připojeného čidla:
pi@raspberrypi ~ $ owread /28.9614C2030000/type
DS18B20
A jakou nám měří teplotu?
pi@raspberrypi ~ $ owread /28.9614C2030000/temperature
20.4375
(Jaké hodnoty jsou v dalších souborech a co s nimi? Nastudujte si za domácí úkol dokumentaci OWFS a datasheet čidla DS18B20.)
Stejným způsobem jako k čidlu se můžeme chovat i k ostatním položkám stromu OWFS. Třeba můžeme zjisti, jaký bus master je použit pro bus.0:
pi@raspberrypi ~ $ owread /bus.0/interface/settings/name
DS2482-100
Jak zde je vidět, OWFS řeší spoustu věcí, ne jen vlastní zjištění teploty. Pro většinu 1-wire zařízení OWFS umožňuje plnohodnotné použití. Například u teplotních čidel je tak možno zjišťovat maxima a minima nebo nastavovat limity pro automatické alerty. Vygenerované alerty pak najdete v cestě /alarm.




$ i2cdetect -y 1
$ i2cdetect -y 'bcm2835 (i2c@7e804000)'
0 1 2 3 4 5 6 7 8 9 a b c d e f
00: -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- 18 -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --


