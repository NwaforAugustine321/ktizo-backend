"""Added columns in similar tracks songs

Revision ID: 1be5a4ddae1c
Revises: 2737e100c02c
Create Date: 2022-05-29 22:35:07.310292

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '1be5a4ddae1c'
down_revision = '2737e100c02c'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('Songs', sa.Column('spotify_artist_id', sa.String(length=255), nullable=True))
    op.add_column('Songs', sa.Column('bpm', sa.String(length=255), nullable=True))
    op.add_column('count_likes', sa.Column('sync', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    op.add_column('similar_track', sa.Column('search_artistname', sa.String(length=255), nullable=True))
    op.add_column('similar_track', sa.Column('search_trackname', sa.String(length=255), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('similar_track', 'search_trackname')
    op.drop_column('similar_track', 'search_artistname')
    op.drop_column('count_likes', 'sync')
    op.drop_column('Songs', 'bpm')
    op.drop_column('Songs', 'spotify_artist_id')
    # ### end Alembic commands ###