# get base samples
all_samples = SonicPi::Synths::BaseInfo.class_eval '@@grouped_samples'

# show all sample headings
puts all_samples.keys.sort
# [:ambi, :bass, :bd, :drum, :elec, :glitch, :guit, :loop, :mehackit, :misc, :perc, :sn, :tabla, :vinyl]

# access samples for a heading
puts all_samples[:drum][:samples]
