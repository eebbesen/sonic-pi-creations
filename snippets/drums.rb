# base sound combos
def snare
  with_fx :reverb do
    sample :drum_snare_hard, pan: -0.3
  end
end

def kick
  with_fx :reverb do
    sample :drum_heavy_kick
    sample :drum_tom_mid_soft, pan: 0.3
  end
end

# doubles the hi-hat if sleep time is passed in
def hh(sleep_time = nil)
  sample :drum_cymbal_pedal, pan: -0.8
  if sleep_time
    sleep sleep_time
    hh
  end
end

# standard hi-hat / kick / snare
# can double hi-hat with @dhh set
# sleep_time will be halved when hi-hat is doubled

# examples
# live_loop :ede do
#   @dhh = false
#   drums_4_4 1
# end
def drums_4_4(sleep_time)
  hhs = @dhh ? sleep_time / 2.0 : nil

  kick
  hh

  if hhs
    sleep hhs
    hh
    sleep hhs
  else
    sleep sleep_time
  end

  snare
  hh

  if hhs
    sleep hhs
    hh
    sleep hhs
  else
    sleep sleep_time
  end
end

# swing gives a bit of swing
# if @dhh is true and swing is false you get a beat in 5
def drums_3_4(sleep_time, swing = false)

  hhs = @dhh || swing ? sleep_time / 2.0 : nil

  kick
  hh

  if hhs
    sleep hhs
    hh
    sleep hhs
  else
    sleep sleep_time
  end

  if hhs
    sleep hhs if swing
    hh
    sleep hhs
  else
    sleep sleep_time
  end

  snare
  hh

  if hhs
    sleep hhs
    hh
    sleep hhs
  else
    sleep sleep_time
  end
end

def drums_5_4(sleep_time)
  @dhh = true
  drums_3_4
end