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

def hh
  sample :drum_cymbal_pedal, pan: -0.8
end

# standard hi-hat / kick / snare
# can double hi-hat with @dhh set
# sleep_time will be halved when hi-hat is doubled
def explicit_drums_4_4(sleep_time)
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
