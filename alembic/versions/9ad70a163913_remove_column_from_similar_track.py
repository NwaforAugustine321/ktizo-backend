"""Remove column from similar track

Revision ID: 9ad70a163913
Revises: 1be5a4ddae1c
Create Date: 2022-05-30 15:48:44.410389

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '9ad70a163913'
down_revision = '1be5a4ddae1c'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint('similar_track_song_id_fkey', 'similar_track', type_='foreignkey')
    op.drop_column('similar_track', 'artist_id')
    op.drop_column('similar_track', 'song_id')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('similar_track', sa.Column('song_id', postgresql.UUID(), autoincrement=False, nullable=False))
    op.add_column('similar_track', sa.Column('artist_id', postgresql.UUID(), autoincrement=False, nullable=True))
    op.create_foreign_key('similar_track_song_id_fkey', 'similar_track', 'Songs', ['song_id'], ['id'], ondelete='CASCADE')
    # ### end Alembic commands ###