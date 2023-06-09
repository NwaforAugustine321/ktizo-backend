"""alter table  myearnings added invoice_number

Revision ID: 6b1d5c9b72ff
Revises: 8554b68b3083
Create Date: 2022-06-08 16:37:09.709132

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '6b1d5c9b72ff'
down_revision = '8554b68b3083'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('my_earnings', sa.Column('invoice_number', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('my_earnings', 'invoice_number')
    # ### end Alembic commands ###
